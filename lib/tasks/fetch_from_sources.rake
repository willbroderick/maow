namespace :fetch_from_sources do
  desc 'Fetch all articles from all sources'
  task all: :environment do
    @total = 0
    ms = Benchmark.ms do
      Source.where(enabled: true).each do |source|
        @total = @total + source.fetch
      end
    end
    puts "Articles fetched: #{@total} in #{(ms/1000).to_i}s"
  end
end
