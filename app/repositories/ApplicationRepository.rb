class ApplicationRepository

    def initialize() 
    end

    def get_all
        return Application.all
    end

    def get_by_token(token)
        return Application.find_by(token: token)
    end

    def is_token_exists(unique_identifier)
        return Application.exists?(:token => unique_identifier)
    end

    def create_application(name,token)
        return Application.create(name: name, token: token)
    end

end