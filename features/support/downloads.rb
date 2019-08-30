module DownloadHelpers
  TIMEOUT = 10
  PATH    = [Dir.pwd(), 'tmp','downloads']
  # ALL_FILES = File.join(PATH, '*')

  extend self

  def downloads
    Dir[File.join(Dir.pwd(),'tmp','downloads', "*")]
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    File.read(download)
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    binding.pry
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.crdownload$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end

World(DownloadHelpers)

Before do
  clear_downloads
end

After do
  clear_downloads
end