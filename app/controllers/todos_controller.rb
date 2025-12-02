class TodosController < ApplicationController
  before_action :set_todo, only: [ :toggle, :destroy ]

  # GET /todos
  def index
    start_date = params.fetch(:start_date, Date.today).to_date

    @todos = current_user.todos
                        .where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
                        .order(created_at: :asc)
  end

  def create
    @todo = current_user.todos.build(todo_params)

    # Set default start_time if not provided
    @todo.start_time ||= Date.today

    if @todo.save
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todo was successfully created." } # fallback
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_todo",
            partial: "todos/form",
            locals: { todo: @todo }
          ), status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path, notice: "Todo was successfully deleted." } # fallback
    end
  end

  # PATCH /todos/:id/toggle
  def toggle
    @todo.update(complete: !@todo.complete)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path } # fallback
    end
  end

  def daily
    @target_date = Date.parse(params[:date])

    @daily_todos = current_user.todos
                              .where(start_time: @target_date.all_day)
                              .order(created_at: :asc)

    render layout: false
  end

  # GET /todos/report?date=YYYY-MM-DD
  def report
    target_date = Date.parse(params[:date]) rescue Date.today
    next_date = target_date + 1.day

    # Log report generation
    current_user.report_logs.create!(log_date: target_date)

    # 1. [Today] Completed Todos
    done_todos = current_user.todos
                              .where(start_time: target_date.all_day, complete: true)
                              .order(created_at: :asc)
                              .pluck(:content)

    # 2. [Tomorrow] Planned Todos
    next_todos = current_user.todos
                              .where(start_time: next_date.all_day)
                              .order(created_at: :asc)
                              .pluck(:content)

    # 3.
    wdays = [ "日", "月", "火", "水", "木", "金", "土" ]
    date_str = "#{target_date.strftime("%Y年%m月%d日")}(#{wdays[target_date.wday]})"

    # 3. Respond with JSON
    render json: {
      date_str: date_str,
      done_todos: done_todos,
      next_todos: next_todos
    }
  end

  private

  def todo_params
    params.require(:todo).permit(:content, :start_time)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
