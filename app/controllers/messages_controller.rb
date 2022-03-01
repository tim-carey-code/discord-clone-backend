class MessagesController < ApplicationController
    def index
        @chatroom = Chatroom.find(params[:chatroom_id])

        @message = @chatroom.messages.all
        render json: @message
    end

    def create
        @chatroom = Chatroom.find(params[:chatroom_id])
        @message = @chatroom.messages.create(message_params)
        @message.user_id = @current_user.id
        if @message.save
            render json: @message, status: :created 
        else
            render json: @message.errors, status: :unprocessable_entity
        end
    end

    def show
        @chatroom = Chatroom.find(params[:chatroom_id])
        @message = @chatroom.messages.find(params[:id])

        render json: @message
    end

    def update 
        @chatroom = Chatroom.find(params[:chatroom_id])
        @message = @chatroom.messages.find(params[:id])
        @message_owner = @message.user_id

        if @current_user.id != @message_owner 
            render json: {message: "You are not authorized to edit this message"}
        elsif @message.update(message_params)
            render json: @message, status: :ok
        else 
            render json: @message.errors, status: :unprocessable_entity
        end
    end



    def destroy 
        @chatroom = Chatroom.find(params[:chatroom_id])
        @message = @chatroom.messages.find(params[:id])
        @message_owner = @message.user_id 

        if @current_user.id != @message_owner
            render json: {message: "You are not authorized to delete this message"}
        elsif @message.destroy
            render json: {message: 'Sucessfully deleted message'}
        else
            render json: @message.errors, staus: :unprocessable_entity
        end
    end


    private
        def message_params 
            params.require(:message).permit(:text)
        end
end
