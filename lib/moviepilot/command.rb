# 
# Moviepilot CLI commands
# 
# Encoding: utf-8

require 'commander'
require 'terminal-table'
require 'premailer/html_to_plain_text'

module Moviepilot
  class Command
    include Commander::Methods
    include HtmlToPlainText

    def run
      program :name, 'Moviepilot CLI'
      program :version, '0.0.1'
      program :description, 'Access the best content of the movies you love, from your command line!'

      default_command :help

      command :trending do |c|
        c.syntax = 'moviepilot trending'
        c.description = 'Display the hotest posts.'
        c.action do |args, options|
          top = Client.trending
          if top['collection'].any?
            rows = [] 
            top['collection'].each_with_index do |post, i|
              title = post['title'].length <= 27 ? post['title'] : post['title'][0..27] + '...'
              author = post['author']['name'] || post['author']['user_name']
              rows << [i + 1, post['id'], title, author]
            end
            table = Terminal::Table.new title: 'TOP POSTS', headings: %w(# ID TITLE AUTHOR), rows: rows
            puts "\n#{table}\n\n"
          else
            puts "\nOops! There are no trending posts right now.\n\n"
          end
        end
      end

      command :post do |c|
        c.syntax = 'moviepilot posts <id>'
        c.description = 'Display an specific post.'
        c.action do |args, options|
          begin
            post = Client.post args[0]
            puts "\n*** #{post['title']} (#{args[0]}) ***\n\n"
            enable_paging  
            puts convert_to_text(post['html_body'])
          rescue RestClient::ResourceNotFound => e
            puts "\nOops! The post #{args[0]} doesn't exist.\n\n"
          end
        end
      end

      command :search do |c|
        c.syntax = 'moviepilot search <text> [options]'
        c.option '--page INTEGER', Integer, 'Results page'
        c.description = 'Search for content matching the specified text.'
        c.action do |args, options|
          options.default page: 1
          query, page = args[0], options.page
          results = Client.search query, page: page, api_version: 'v3'
          if results['search'].any?
            puts "\n#{results['total']} results for '#{query}'\n\n"
            results['search'].each do |result|
              puts "• #{result['name']} (#{result['type'].capitalize})"
            end
            puts "\nPage: #{page}/#{results['total_pages']}\n\n"
          else
            puts "\nOops! No results found for '#{query}' on page #{page}.\n\n"
          end
        end
      end

      run!
    end
  end
end