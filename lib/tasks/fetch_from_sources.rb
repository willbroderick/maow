class FetchFromSources
  include Delayed::RecurringJob
  run_every 4.hours
  run_at '02:00am'
  queue 'slow-jobs'

  def perform
    @total = 0
    ms = Benchmark.ms do
      Source.where(enabled: true).each do |source|
        @total = @total + source.fetch
      end
    end
    puts "Articles fetched: #{@total} in #{(ms/1000).to_i}s"
  end
end
