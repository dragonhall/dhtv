# frozen_string_literal: true

class PlaylistHasNoTracksError < StandardError; end

class Playlist < ApplicationRecord
  belongs_to :channel
  has_many :tracks, dependent: :destroy

  scope :finalized, -> { where(finalized: true) }
  scope :wip, -> { where(finalized: false) }
  scope :at_today, lambda {
    where('playlists.start_time >= ? AND playlists.start_time <= ?',
          Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)
  }
  scope :at_week, lambda {
    where('playlists.start_time >= ? AND playlists.start_time <= ?',
          Time.zone.now.beginning_of_week, Time.zone.now.end_of_week)
  }

  scope :active, -> { joins(:tracks).where('tracks.playing = ?', true) }
  scope :upcoming, -> { where(finalized: true) }
  scope :current, lambda {
    where('playlists.start_time BETWEEN ? AND ?',
          Time.zone.now.beginning_of_week, Time.zone.now.end_of_week)
  }

  default_scope -> { includes(:tracks).order(start_time: 'ASC') }

  validates_presence_of :title
  validates_presence_of :start_time
  validates_uniqueness_of :start_time

  before_save :calculate_duration
  after_initialize :initialize_title

  def active?
    tracks.where(playing: true).any?
  end

  def finalize!
    if tracks.count.positive?
      update_attribute :finalized, true
    else
      raise PlaylistHasNoTracksError, 'No tracks added to the tracklist'
    end
  end

  def end_time
    start_time + duration
  end

  def program_as_json
    {
      title: title,
      start_time: start_time,
      end_time: end_time,
      tracks: {}
    }
  end

  def stop
    tracks.where(playing: true).each(&:stop!)
  end

  def renumber!
    tracks.each_with_index do |track, index|
      track.update_attribute :position, index if track.position != index
    end
  end

  def stream_to_technical
    StreamingJob.perform_later clone_to_technical
  end

  def clone_to_technical
    unless Channel.where(domain: '#technical').any?
      Channel.create(
        name: 'Technical channel',
        domain: '#technical',
        stream_path: 'dragonhall_teszt',
        icon: nil, logo: nil
      )
    end

    # Do not clone itself to technical if we are already on technical channel
    if channel.domain == '#technical'
      self
    else
      new_playlist = Channel.where(domain: '#technical').first.playlists.create(
        title: "Playlist##{id}",
        start_time: 1.minutes.from_now
      )

      tracks.each do |track|
        new_playlist.tracks.create(video: track.video)
      end

      new_playlist.save

      new_playlist
    end
  end

  def program_path
    "/programs/channel_#{channel.id}/#{id}/#{start_time.strftime('%F_%H-%M')}.png"
  end

  def program?
    Rails.public_dir.join(program_path.sub(%r{^/}, '')).exist?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def human_title
    if !defined?(@human_title) || @human_title.blank?
      @human_title = if start_time.to_date == Time.zone.now.to_date
                       'Mai'
                     elsif start_time.to_date == (Time.zone.now - 1.day).to_date
                       'Tegnapi'
                     elsif start_time.to_date == (Time.zone.now + 1.day).to_date
                       'Holnapi'
                     elsif start_time >= Time.zone.now.to_date.beginning_of_week &&
                           start_time <= Time.zone.now.to_date.end_of_week
                       # 'Heti'
                       I18n.l(start_time, format: '%Ai').titleize
                     elsif start_time >= 7.days.from_now.to_date.beginning_of_week &&
                           start_time <= 7.days.from_now.to_date.end_of_week
                       'Jövő Heti'
                     else
                       start_time > Time.now.end_of_day ? 'Következő' : 'Előző'
                     end
      @human_title += ' Műsor'
    end
    @human_title
  end

  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  private

  def calculate_duration
    unless finalized? || tracks.where(playing: true).any?
      self.duration = tracks.collect(&:length).sum
    end
  end

  def initialize_title
    if new_record?
      self.title ||= "#{channel ? channel.name : Playlist.model_name} " \
                     "##{channel.playlists.last.blank? ? 1 : channel.playlists.last.id + 1}"
    end
  end
end
