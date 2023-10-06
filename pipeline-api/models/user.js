
class User {
    constructor(name, email, password) {
      this.name = name;
      this.email = email;
      this.password = password;
    }
  
    get() {
      return {
        name: this.name,
        email: this.email,
        password: this.password,
      };
    }
  }
  
  module.exports = User;

  