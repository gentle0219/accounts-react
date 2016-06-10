# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@Records = React.createClass
  getInitialState: ->
    records: @props.data
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { record: @state }, (data) =>
      @props.handleNewRecord data
      @setState @getInitialState()
    , 'JSON'
  addRecord: (record) ->
    records = React.addons.update(@state.records, { $push: [record] })
    @setState records: records
  credits: ->
    credits = @state.records.filter (val) -> val.amount >= 0
    credits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  debits: ->
    debits = @state.records.filter (val) -> val.amount < 0
    debits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  balance: ->
    @debits() + @credits()
  deleteRecord: (record) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1]] })
    @replaceState records: records
    # records = @state.records.slice()
    # index = records.indexOf record
    # records.splice index, 1
    # @replaceState records: records

  render: ->
    React.DOM.div
        className: 'records'
        React.DOM.h2
          className: 'title'
          'Records'
        React.DOM.div
          className: 'row'
          React.createElement AmountBox, type: 'success', amount: @credits(), text: 'Credit'
          React.createElement AmountBox, type: 'danger', amount: @debits(), text: 'Debit'
          React.createElement AmountBox, type: 'info', amount: @balance(), text: 'Balance'

        React.createElement RecordForm, handleNewRecord: @addRecord
        React.DOM.hr null

        React.DOM.table
          className: 'table table-striped table-bordered'
          React.DOM.thead null,
            React.DOM.tr null,
              React.DOM.th null, 'Date'
              React.DOM.th null, 'Title'
              React.DOM.th null, 'Amount'
              React.DOM.th null, 'Actions'
          React.DOM.tbody null,
            for record in @state.records
              React.createElement Record, key: record.id, record: record, handleDeleteRecord: @deleteRecord
