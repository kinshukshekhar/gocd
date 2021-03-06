##########################GO-LICENSE-START################################
# Copyright 2014 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################GO-LICENSE-END##################################

require File.join(File.dirname(__FILE__), "../../../../spec_helper")

describe "admin/tasks/new_exec.html.erb" do
  include GoUtil, TaskMother, FormUI

  before :each do
    assigns[:cruise_config] = config = CruiseConfig.new
    set(config, "md5", "abcd1234")

    assigns[:on_cancel_task_vms] = @vms =  java.util.Arrays.asList([vm_for(exec_task('rm')), vm_for(ant_task), vm_for(nant_task), vm_for(rake_task), vm_for(fetch_task)].to_java(TaskViewModel))
    template.stub(:admin_task_create_path).and_return("task_create_path")
  end

  it "should render a simple exec task for create" do
    task = assigns[:task] = simple_exec_task

    assigns[:task_view_model] = Spring.bean("taskViewService").getViewModel(task, 'new')

    render "/admin/tasks/plugin/new"

    response.body.should have_tag("form[action=?]", 'task_create_path')
    response.body.should have_tag("form") do
      with_tag("div.fieldset" ) do
        with_tag("label", "Command*")
        with_tag("input[name='task[command]']")
        with_tag("label", "Arguments")
        with_tag("input[type='text'][name='task[args]']")
        with_tag("label", "Working Directory")
        with_tag("input[name='task[workingDirectory]']")
      end
    end
  end

  it "should display empty div to load gist based auto complete" do
    task = assigns[:task] = simple_exec_task
    assigns[:task_view_model] = Spring.bean("taskViewService").getViewModel(task, 'new')

    render "/admin/tasks/plugin/new"

    response.body.should have_tag("div.gist_panel") do
      with_tag("div.gist_lookup")
      without_tag("div.gist_lookup .gist_based_auto_complete")
    end
  end
end

