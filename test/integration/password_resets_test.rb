require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
def setup
  @notadmin = users(:mary)
end

  test "When the user clicks the 'forgot password' link, the password_resets#new
  template is rendered" do
  	get admin_login_path
  	assert_template 'sessions#new'
  	get new_admin_password_reset_path
  	assert_template 'password_resets#new'
  #	assert_ terminar mañana
  end
  # la pagina de new reset se muestra correctamente
  # el mail no se envia si el email no existe
  # el mail se envia correctamente si el mail existe
  # la pagina de modificar password se muestra correctamente, e incluye token
  # reset correcto modifica el usuario y envia a su pagina
  # reset incorrecto NO modifica el usuario y envia de vuelta a editar password
  # el reset tiene q ser dentro del plazo


end
