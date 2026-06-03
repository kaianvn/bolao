namespace :bolao do
  desc 'Sync World Cup 2026 results from the public openfootball JSON source'
  task sync_worldcup_results: :environment do
    synced = Bolao::WorldcupResultsSync.call
    puts "Synced #{synced} matches"
  end
end