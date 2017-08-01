var usersMostBookingsChart = document.getElementById("usersMostBookings").getContext('2d');
const chartsUsersMostBookings = {
    type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: 'Total Reservations',
            data: [],
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)'
            ],
            borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        }
    }
}
$.ajax({
  method: 'GET',
  url: '/api/v1/users/reservations/bookings?limit=5',
  success: function(response){ renderUsersMostBookings(response) },
  error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
});
const renderUsersMostBookings = function(users_most_bookings){
  for(var i = 0, len = users_most_bookings.length; i < len; i++) {
    let user = users_most_bookings[i];
    chartsUsersMostBookings.data.labels.push(user.first_name + " " + user.last_name);
    chartsUsersMostBookings.data.datasets[0].data.push(user.total);
  }
  var myChart = new Chart(usersMostBookingsChart, chartsUsersMostBookings);
}
