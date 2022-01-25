class BookingsController < ApplicationController
  before_action :find_dress, only: %i[new create destroy]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)

    # @booking.dress = @dress
    # @booking.user = current_user
    # Uneeded due to passing user and dress in params
    if @booking.save
      redirect_to booking_path
      # Changed path from "bookings_path to booking_path."
    else
      render :new
    end
    # change status?
  end

  def destroy
    @booking = Booking.find(params[:id])
    flash[:remove] = "\"#{@dress.brand} dress\" removed from bookings"
    # flash message to notify dress has been removed from bookings
    @booking.destroy
    redirect_to booking_path
    # Changed path from "bookings_path to booking_path."
  end

  private

  def booking_params
    params.require(:booking).permit(:starting_date, :ending_date, :status, :user_id, :dress_id)
  end

  def find_dress
    @dress = Dress.find(params[:dress_id])
  end
end
