var reservationsByMonthChart = document.getElementById("reservationsByMonth").getContext('2d');
const chartReservationsByMonth = {
    type: 'line',
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
            }],
            xAxes: [{ticks:{autoSkip: false}}]
        }
    }
}
$.ajax({
  method: 'GET',
  url: '/api/v1/reservations/by_month',
  success: function(response){ renderReservationsByMonth(response) },
  error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
});
const renderReservationsByMonth = function(reservations_by_month){
  for(var i = 0, len = reservations_by_month.length; i < len; i++) {
    let month = reservations_by_month[i];
    chartReservationsByMonth.data.labels.push(month.month);
    chartReservationsByMonth.data.datasets[0].data.push(month.count);
  }
  var myChart = new Chart(reservationsByMonthChart, chartReservationsByMonth);
}
