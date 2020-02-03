class RanksJob < ApplicationJob
  queue_as :default

  def perform report_id
    report = Report.find report_id

    report.update \
      result: PointsCalculator.new(report.repo).top_ten,
      state: 'ready'
  end
end
