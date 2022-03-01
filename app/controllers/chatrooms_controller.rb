class ChatroomsController < ApplicationController
    before_action :set_chatroom, only: [:show, :update, :destroy]
    before_action :authenticate_request



    def index
        @chatroom = Chatroom.all

        render json: @chatroom
    end

    def show
        
        render json: @chatroom
    end


    def create
        @chatroom = Chatroom.create(chatroom_params)
        @chatroom.user_id = current_user.id
        if @chatroom.save
            render json: @chatroom, status: :created
        else
            render json: @chatroom.errors, status: :unprocessable_entity
        end
    end

    def update
        @chatroom = Chatroom.find(params[:id])
        @room_owner = @chatroom.user_id

        if current_user.id != @room_owner
            render json: {message: "You are not authorized to edit this room"}
        elsif @chatroom.update(chatroom_params)
            render json: @chatroom 
        else
            render json: @chatroom.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @chatroom = Chatroom.find(params[:id])
        @room_owner = @chatroom.user_id

        if current_user.id != @room_owner
            render json: {message: "You are not authorized to delete this room"}
        elsif @chatroom.destroy 
            render json: {message: "Chat room #{@chatroom.room_name} sucessfully deleted"}
        else
            render json: @chatroom.errors, status: :unprocessable_entity
        end
    end


    private
        def set_chatroom
            @chatroom = Chatroom.find(params[:id])
        end

        def chatroom_params
            params.require(:chatroom).permit(:room_name, :user_id)
        end
end