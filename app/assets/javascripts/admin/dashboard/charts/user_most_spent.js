const userMostSpentLabel = 'Total Amount Spent';
const userMostSpentColor = 'rgba(153, 102, 255, 0.2)';
const userMostSpentBorder = 'rgba(153, 102, 255, 1)';

const getUserMostSpent = (limit = 5) => {
  $.ajax({
    method: 'GET',
    url: '/api/v1/users/money/most_spent?limit=' + limit,
    success: function(response){
      removeData(chart);
      addData(chart, response, userMostSpentLabel, userMostSpentColor, userMostSpentBorder)
    },
    error: function(xhr,textStatus,errorThrown) { console.log(xhr,textStatus,errorThrown) }
  });
}
