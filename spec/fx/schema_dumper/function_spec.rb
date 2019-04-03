require "spec_helper"

describe Fx::SchemaDumper::Function, :db do
  it "dumps a create_function for a function in the database" do
    sql_definition = <<-EOS
      CREATE OR REPLACE FUNCTION test()
      RETURNS text AS $$
      BEGIN
          RETURN 'test';
      END;
      $$ LANGUAGE plpgsql;
    EOS
    connection.create_function :test, sql_definition: sql_definition
    stream = StringIO.new

    ActiveRecord::SchemaDumper.dump(connection, stream)

    output = stream.string
    expect(output).to include "create_function :test, sql_definition: <<-SQL"
    expect(output).to include "CREATE OR REPLACE FUNCTION test()"
    expect(output).to include "RETURN 'test';"
  end

  it "dumps a create_function without a schema qualifier" do
    sql_definition = <<-EOS
      CREATE OR REPLACE FUNCTION public.test()
      RETURNS text AS $$
      BEGIN
          RETURN 'test';
      END;
      $$ LANGUAGE plpgsql;
    EOS
    connection.create_function :test, sql_definition: sql_definition
    stream = StringIO.new

    ActiveRecord::SchemaDumper.dump(connection, stream)

    output = stream.string
    expect(output).to include "create_function :test, sql_definition: <<-SQL"
    expect(output).to include "CREATE OR REPLACE FUNCTION test()"
    expect(output).to include "RETURN 'test';"
  end
end
