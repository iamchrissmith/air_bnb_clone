const barChartOptions = {
    type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: '',
            data: [],
            backgroundColor: '',
            borderColor: '',
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
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

const addData = (chart, new_dataset, label, color, border) => {
    chart.data.datasets[0].label = label;
    chart.data.datasets[0].backgroundColor = color;
    chart.data.datasets[0].borderColor = border;

    for(var i = 0, len = new_dataset.length; i < len; i++) {
      let user = new_dataset[i];
      chart.data.labels.push(user.first_name + " " + user.last_name);
      chart.data.datasets[0].data.push(user.total);
    }

    chart.update();
}

const removeData = (chart) => {
  chart.data.labels = [];
  chart.data.datasets[0].data = [];
  chart.update();
}

const chartEl = document.getElementById("userMost").getContext('2d');
const chart = new Chart(chartEl, barChartOptions);

const updateChartType = (fnstring) => {
  let limit = $('#user-limit').val();
  switch (fnstring) {
  	case "getUsersMostBookings": getUsersMostBookings(limit); break;
  	case "getUserMostSpent": getUserMostSpent(limit); break;
  	case "getUserMostNights": getUserMostNights(limit); break;
  	case "getOwnersMostRevenue": getOwnersMostRevenue(limit); break;
  }
}

$(document).ready( () => {
  getUsersMostBookings();

  $('#user-filter').on('change', function() {
    updateChartType( $(this).val() );
  });

  $('#user-limit').on('change', function() {
    let filter = $('#user-filter').val();
    updateChartType( filter );
  });
});
