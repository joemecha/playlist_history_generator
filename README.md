# Playlist History Generator

A Ruby on Rails app that signs into [Music League](https://app.musicleague.com), retrieves Spotify playlists for each round, and stores song and playlist data locally. The app provides searchable, sortable views of songs and playlists, export capability, as well as insights and statistics about artist and song choices.

The app now supports multiple leagues, with each playlist belonging to a league.

---

## Table of Contents

- [General Info](#general-info)
- [Live Link](#live-link)
- [Database Schema](#database-schema)
- [Areas of Focus](#areas-of-focus)
- [Setup](#setup)
  - [Local Setup](#local-setup)
- [To-do List](#to-do-list)

---

## General Info

This app was created to make it easier to avoid submitting duplicate songs to a long running Music League league (80+ weeks and counting), and grew to be able to see frequently submitted artists and other basic stats. The app imports each round's playlist via Spotify and stores data in a local database.

Since the app is not currently hosted anywhere, CSV exporting was added to be able to share the data with others in the league. For ease of use and possibility of hosting it somewhere, there is a simple UI styled with bootstrap.

---

## Live Link

TBD

---

## Database Schema

- **Leagues**: store Spotify metadata, and creation date; has many playlists
- **Playlists**: store Spotify metadata, Music League round number, and creation date
- **Songs**: unique by title and artist; includes album name
- **PlaylistSongs**: join table representing which songs appeared in which playlists

<!-- Optionally insert schema diagram here -->
<!-- ![Schema](./path_to_schema.png) -->

---

## Areas of Focus

- Practicing service-oriented architecture and separation of concerns
- Importing and deduplicating data from external APIs (Spotify)
- Exporting tabular data to CSV
- Reporting and analytics (most frequent songs, artists, etc.)

---

## Setup

To run this project locally:

You will need Spotify Developer credentials and a URL for your personal Music League league. See `.env.example` for these variables and needed values. The need for a current Music League cookie will be eliminated once the app has been updated with the ability to use Spotify to log in.

```bash
git clone git@github.com:joemecha/playlist_history_generator.git
cd playlist_history_generator
bundle install
rails db:create
rails db:migrate
rails server
```
---

## TODO List

- Automate Music League login process to avoid depending on session cookies that expire