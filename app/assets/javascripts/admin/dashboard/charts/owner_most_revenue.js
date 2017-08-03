const usersMostRevenueLabel = 'Total Revenue';
const usersMostRevenueColor = 'rgba(54, 162, 235, 0.2)';
const usersMostRevenueBorder = 'rgba(54, 162, 235, 1)';

const getOwnersMostRevenue = (limit = 5) => {
  $.ajax({
    method: 'GET',
    url: '/api/v1/users/money/most_revenue?limit=' + limit,
    success: function(response){
      removeData(chart);
      addData(chart, response, usersMostRevenueLabel, usersMostRevenueColor, usersMostRevenueBorder)
    },
    error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
  });
}
