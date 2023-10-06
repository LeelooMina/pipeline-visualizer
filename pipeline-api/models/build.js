class Build {
    constructor(number, branch_name, uuid, status, duration_seconds, build_seconds_used, steps, started_on, completed_on, ) {
      this.number = number;
      this.branch_name = branch_name;
      this.uuid = uuid;
      this.status = status;
      this.duration_seconds = duration_seconds;
      this.build_seconds_used = build_seconds_used;
      this.steps = steps;
      this.created_on = started_on;
      this.completed_on = completed_on;
    }
  
  }
  
  module.exports = Build;
  

  