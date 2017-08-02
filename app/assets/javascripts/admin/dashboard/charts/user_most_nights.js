var usersMostNightsChart = document.getElementById("usersMostNights").getContext('2d');
const chartUsersMostNights = {
    type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: 'Total Nights',
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
            }],
            xAxes: [{ticks:{autoSkip: false}}]
        }
    }
}
$.ajax({
  method: 'GET',
  url: '/api/v1/users/reservations/nights?limit=5',
  success: function(response){ rendersUsersMostNights(response) },
  error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
});
const rendersUsersMostNights = function(users_most_nights){
  for(var i = 0, len = users_most_nights.length; i < len; i++) {
    let user = users_most_nights[i];
    chartUsersMostNights.data.labels.push(user.first_name + " " + user.last_name);
    chartUsersMostNights.data.datasets[0].data.push(user.total);
  }
  var myChart = new Chart(usersMostNightsChart, chartUsersMostNights);
}
