if Rails.env.production? or Rails.env.staging?
  GA.tracker = 'UA-103621196-1'
end
