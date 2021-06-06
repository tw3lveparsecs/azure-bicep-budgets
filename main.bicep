@description('Budget name')
param budgetName string = subscription().displayName

@description('The total amount of cost or usage to track with the budget')
param amount int

@description('The category of the budget, whether the budget tracks cost or usage')
param category string

@description('The time window covered by the budget. Tracking of the amount will be reset based on the reset period')
@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
param resetPeriod string

@description('The start date of the budget in date format YYYY-MM-DD. Start date should not exceed more than three months in the future.')
param startDate string

@description('The end date of the budget in date format YYYY-MM-DD. If not provided will default to 10 years from start date.')
param endDate string = ''

@description('Budget notifications')
@metadata({
  enabled: 'Boolean to enable budget'
  operator: 'Budget operator, e.g. GreaterThan'
  threshold: 'Integer specifying the threshold value associated with the notification. Notification is sent when the cost exceeded the threshold'
  contactEmails: [
    'The list of email addresses to send the budget notification to when the threshold is exceeded'
  ]
  contactRoles: [
    'The list of contact roles to send the budget notification to when the threshold is exceeded.'
  ]
  contactGroups: [
    'The list of action groups to send the budget notification to when the threshold is exceeded.'
  ]
})
param notifications object = {
  notification1: {
    enabled: true
    operator: 'GreaterThan'
    threshold: 50
    contactEmails: [
      'john.smith@microsoft.com'
    ]
    contactRoles: [
      'Owner'
    ]
    contactGroups: []
  }
  notification2: {
    enabled: true
    operator: 'GreaterThan'
    threshold: 90
    contactEmails: [
      'john.smith@microsoft.com'
    ]
    contactRoles: [
      'Owner'
    ]
    contactGroups: []
  }
}

resource budget 'Microsoft.Consumption/budgets@2021-05-01' = {
  name: budgetName
  properties: {
    amount: amount
    category: category
    timeGrain: resetPeriod
    timePeriod: {
      startDate: startDate
      endDate: !empty(endDate) ? endDate : null
    }
    notifications: !empty(notifications) ? notifications : null
  }
}
