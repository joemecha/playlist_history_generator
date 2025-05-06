class SongsController < ApplicationController
  def index
    @songs = Song.includes(:playlist_songs).order(:title)
  end

  def import
    PlaylistSongImporter.new.import_all
    redirect_to songs_path, notice: "Songs imported successfully."
  end
end
