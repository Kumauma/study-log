class MypageController < ApplicationController
  def show
    range = Date.today.beginning_of_month..Date.today

    todos_in_range = current_user.todos.where(start_time: range)

    @total_count = todos_in_range.count
    @done_count  = todos_in_range.where(complete: true).count

    @percentage = @total_count > 0 ? ((@done_count.to_f / @total_count) * 100).round : 0

    @monthly_report_count = current_user.report_logs
                                        .where(log_date: range)
                                        .count
  end

  def preview_markdown
    @content = params[:preview]&.dig(:content) || ""
  end

  def reset_markdown
  end
end
