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

## Architecture

- **Rails app**
  - Handles authentication, data ingestion, and persistence
  - Renders the UI and exposes internal service objects for imports

- **PostgreSQL**
  - Primary data store for leagues, playlists, rounds, songs, and artists

- **Spotify API**
  - Used to authenticate users and retrieve playlist and track metadata

- **Music League**
  - Source of league and playlist URLs
  - Playlist metadata is extracted from league pages

### Data Flow

1. User authenticates via Spotify
2. The application identifies leagues and associated playlists
3. Playlist tracks are fetched from Spotify
4. Normalized song and artist data is persisted
5. Historical playlist data can be exported or analyzed

### Hosting

- **Web application:** Render
- **Database:** Supabase (PostgreSQL)

## Areas of Focus

- Practicing service-oriented architecture and separation of concerns
- Importing and deduplicating data from external APIs (Spotify)
- Exporting tabular data to CSV
- Reporting and analytics (most frequent songs, artists, etc.)

---

## Setup

To run this project locally:

You will need Spotify Developer credentials and a URL for your personal Music League league. See `.env.example` for these variables and needed values. The need for a current Music League cookie will be eliminated once the app has been updated with the ability to use Spotify to log in.

### Prequisites

- Ruby
- Bundler
- PostgreSQL
- Spotify developer account

reate a local environment configuration using the variables documented in `.env.example`.

At minimum, you will need:

- Spotify client credentials
- A Music League league URL
- A valid Music League session cookie (temporary requirement)

> Note: The requirement for a Music League session cookie is temporary and will be removed once Spotify-based authentication is fully implemented.

### Rails App Setup

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

[X] Add devise, authorize user check, sign in/up, logout functionality
[X] Add annotate gem and generate schema comments for all models
[X] Update user with admin field, begin using policies to control visibility and functionality of data scraping
[X] Restrict registration to members of the current league
[X] Decide how to handle secrets safely
[X] deploy app to host
[ ] Improve load times (e.g. playlist and song index pages)
