Rails.application.routes.draw do
  get '(/:path)', to: 'static#display', :constraints => {:path => /.*/}
end
