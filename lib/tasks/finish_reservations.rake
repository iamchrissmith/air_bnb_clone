namespace :fairbnb do
  desc 'Look for reservations who have an end_date in the past and mark them as status: finished'
  task finish_reservations: :environment do
    puts "Marking past reservations as finished"
    ReservationToFinishedJob.perform_now
  end
end
