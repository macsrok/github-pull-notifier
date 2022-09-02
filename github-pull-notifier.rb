require 'rubygems'
require 'faraday'
require 'JSON'

TOKEN = ''.freeze
ALLOWED_GITHUB_USERS = %w[].freeze
SLACK_TOKEN =''.freeze
CHANNEL_ID = ''.freeze
GITHUB_TO_SLACK_MAP = {}.freeze
OWNER = ''.freeze
REPO = ''.freeze

def fetch_pull_requests
  @pull_requests ||= filter_pull_requests(make_get_request("https://api.github.com/repos/#{OWNER}/#{REPO}/pulls"))
end

def filter_pull_requests(pull_requests)
  pull_requests.select do |pull_request|
    ALLOWED_GITHUB_USERS.include?(pull_request['user']['login'])
  end
end

def users_who_have_reviewed(pr)
  url = "https://api.github.com/repos/beachyapp/#{OWNER}/#{REPO}/#{pr['number']}/reviews"
  make_get_request(url).map do |review|
    review['user']['login']
  end
end

def requested_reviewers(pr)
  pr['requested_reviewers'].map do |reviewer|
    reviewer['login']
  end
end

def make_get_request(url)
  JSON.parse(Faraday.new(
    url: url,
    headers: {'Authorization': "Bearer #{TOKEN}", 'Accept': 'application/vnd.github+json'}
  ).get.body)
end

def determine_which_prs_need_review
  @notifcations = {}
  fetch_pull_requests
  @pull_requests.each do |pr|
    reviewers_who_need_review = requested_reviewers(pr) - users_who_have_reviewed(pr)
    @notifcations[pr['number']] = reviewers_who_need_review unless reviewers_who_need_review.empty?
  end
  puts @notifcations.inspect
end

def post_to_slack
  resp = Faraday.new(
    url: 'https://slack.com/api/chat.postMessage',
    headers: { 'Authorization': "Bearer #{SLACK_TOKEN}", 'Content-type': 'application/json' }
  ).post do |req|
    req.body = { channel: CHANNEL_ID, text: build_slack_message, link_names: true }.to_json
  end
  puts resp.body
end

def build_slack_message
  msg = ''
  @notification_hash.each do |user, urls|
    msg << "<@#{GITHUB_TO_SLACK_MAP[user.to_sym]}> friendly reminder the following PRs need your review:\n"
    urls.each do |url|
      msg << "  #{url}\n"
    end
    msg << "\n"
  end
  msg
end

determine_which_prs_need_review
@notification_hash = {}
@slack_msg = ''
@notifcations.each do |pr_number, reviewers|
  reviewers.each do |reviewer|
    @notification_hash[reviewer] ||= []
    pr = @pull_requests.find { |pr| pr['number'] == pr_number }
    @notification_hash[reviewer] << pr['html_url']
  end
end

post_to_slack
