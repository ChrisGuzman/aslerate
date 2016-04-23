class VideoController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    words = asl_params["words"] || ""
    scrub_words = words.gsub(/[^A-Za-z ]/, '')
    puts "words are #{scrub_words}"
    # puts `pwd && bin/stitcher.sh`
    # puts `"bash stitcher.sh #{scrub_words}"`
    cmd = "./stitcher.sh '#{scrub_words}'"
    # cmd = "echo '#{scrub_words}'"
    if  words.present? && system("#{cmd}")
      render plain: view_url
    else
      render plain: "Couldn't parse that"
    end
  end

  def view
    file = File.join(Rails.root, "final.mp4")
    send_file file, type: "video/mp4", disposition: 'inline'
  end

  private
  def asl_params
    params.permit(:words)
  end
end
