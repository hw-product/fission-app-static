Rails.application.routes.draw do
  get '(s/:path)', to: 'static#display', :constraints => {:path => /.*/}
end
