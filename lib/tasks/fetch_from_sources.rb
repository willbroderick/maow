# class FetchFromSources
#   include Delayed::RecurringJob
#   run_every 1.day
#   run_at { ['06:00','10:00','16:00','22:00'] }
#   queue 'slow-jobs'

#   def perform
#     @total = 0
#     ms = Benchmark.ms do
#       Source.where(enabled: true).each do |source|
#         @total = @total + source.fetch
#       end
#     end
#     puts "Articles fetched: #{@total} in #{(ms/1000).to_i}s"
#   end
# end
