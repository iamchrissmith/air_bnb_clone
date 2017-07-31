var ctx = document.getElementById("usersMostRevenue").getContext('2d');
const chartOptions = {
    type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: 'Total Revenue',
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
  url: '/api/v1/users/money/most_revenue?limit=5',
  success: function(response){ renderChart(response) },
  error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
});
const renderChart = function(users_most_revenue){
  console.log(chartOptions)
  const users = [];
  const revenues = [];
  for(var i = 0, len = users_most_revenue.length; i < len; i++) {
    let user = users_most_revenue[i];
    chartOptions.data.labels.push(user.first_name + " " + user.last_name);
    chartOptions.data.datasets[0].data.push(user.total);
  }
  var myChart = new Chart(ctx, chartOptions);
}
