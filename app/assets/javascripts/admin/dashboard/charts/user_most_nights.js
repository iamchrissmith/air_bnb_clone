const userMostNightsLabel = 'Total Nights';
const userMostNightsColor = 'rgba(75, 192, 192, 0.2)';
const userMostNightsBorder = 'rgba(75, 192, 192, 1)';

const getUserMostNights = (limit = 5) => {
  $.ajax({
    method: 'GET',
    url: '/api/v1/users/reservations/nights?limit=' + limit,
    success: function(response){
      removeData(chart);
      addData(chart, response, userMostNightsLabel, userMostNightsColor, userMostNightsBorder)
    },
    error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
  });
}
