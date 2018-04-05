class ChangeCapturedHooksCascade < ActiveRecord::Migration[5.0]
  def up

    connection.execute(%q{
    alter table captured_hooks
    drop constraint fk_captured_hooks_subscriber_id
  })
    connection.execute(%q{
    alter table captured_hooks
    add constraint fk_captured_hooks_subscriber_id
    foreign key (subscriber_id)
    references subscribers(id)
    on delete cascade
  })

  end
end
