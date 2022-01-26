class BookingsController < ApplicationController
  before_action :find_dress, only: %i[new create destroy]

  def index
    @bookings = policy_scope(Booking).order(created_at: :desc)
  end

  def new
    @booking = Booking.new
    authorize @booking
  end

  def show
    @booking = Booking.find(params[:id])
    @dress = @booking.dress
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.dress = @dress
    @booking.user = current_user
    authorize @booking
    if @booking.save
      redirect_to booking_path(@booking)
      # Changed path from "bookings_path to booking_path."
    else
      render :new
    end
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.status = booking_params[:status]
    authorize @booking
    @booking.save
    redirect_to booking_path(@booking)
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    flash[:remove] = "\"#{@dress.brand} dress\" removed from bookings"
    # flash message to notify dress has been removed from bookings
    @booking.destroy
    redirect_to bookings_path
    # Changed path back to "bookings path""
  end

  private

  def booking_params
    params.require(:booking).permit(:starting_date, :ending_date, :status)
  end

  def find_dress
    @dress = Dress.find(params[:dress_id])
  end
end
