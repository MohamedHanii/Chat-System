class ChatService
    
    def initialize(application_repository = ApplicationRepository.new)
        @application_repository = application_repository
    end

end