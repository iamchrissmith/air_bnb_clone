const usersMostBookingsLabel = 'Total Reservations';
const usersMostBookingsColor = 'rgba(255, 206, 86, 0.2)';
const usersMostBookingsBorder = 'rgba(255, 206, 86, 1)';

const getUsersMostBookings = (limit = 5) => {
  $.ajax({
    method: 'GET',
    url: '/api/v1/users/reservations/bookings?limit=' + limit,
    success: function(response){
      removeData(chart);
      addData(chart, response, usersMostBookingsLabel, usersMostBookingsColor, usersMostBookingsBorder)
    },
    error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
  });
}
