namespace :jobs do
  desc 'Look for reservations who have an end_date in the past and mark them as status: finished and reservations that are in progress as in-progress'
  task work: :environment do
    puts "Marking reservations as in-progress and finished"
    ReservationStatusJob.perform_now
  end
end
