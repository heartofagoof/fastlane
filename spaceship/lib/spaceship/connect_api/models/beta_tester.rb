require_relative '../model'
module Spaceship
  class ConnectAPI
    class BetaTester
      include Spaceship::ConnectAPI::Model

      attr_accessor :first_name
      attr_accessor :last_name
      attr_accessor :email
      attr_accessor :invite_type
      attr_accessor :invitation

      attr_accessor :apps
      attr_accessor :beta_groups
      attr_accessor :beta_tester_metrics

      attr_mapping({
        "firstName" => "first_name",
        "lastName" => "last_name",
        "email" => "email",
        "inviteType" => "invite_type",
        "invitation" => "invitation",

        "apps" => "apps",
        "betaGroups" => "beta_groups",
        "betaTesterMetrics" => "beta_tester_metrics"
      })

      def self.type
        return "betaTesters"
      end

      #
      # API
      #

      def self.all(filter: {}, includes: nil, limit: nil, sort: nil)
        return Spaceship::ConnectAPI.get_beta_testers(filter: filter, includes: includes)
      end

      def self.find(email: nil, includes: nil)
        return all(filter: { email: email }, includes: includes).first
      end

      def delete_from_apps(apps: nil)
        app_ids = apps.map(&:id)
        return Spaceship::ConnectAPI.delete_beta_tester_from_apps(beta_tester_id: id, app_ids: app_ids)
      end

      def delete_from_beta_groups(beta_groups: nil)
        beta_group_ids = beta_groups.map(&:id)
        return Spaceship::ConnectAPI.delete_beta_tester_from_beta_groups(beta_tester_id: id, beta_group_ids: beta_group_ids)
      end

      def self.create_beta_tester(email: nil, first_name: nil, last_name: nil, group_ids: nil, build_ids: nil)
        attribuets = {
            email: email,
            firstName: first_name,
            lastName: last_name
        }
        relationships = {}
        unless build_ids.nil? || build_ids.length < 1
          build_ids_data = build_ids.map do |id|
            {
                id: id,
                type: 'builds'
            }
          end
          relationships['builds'] = build_ids_data
        end
        unless group_ids.nil? || group_ids.length < 1
          group_ids_data = group_ids.map do |id|
            {
                id: id,
                type: 'betaGroups'
            }
          end
          relationships['betaGroups'] = group_ids_data
        end
        return Spaceship::ConnectAPI.create_beta_tester(attributes: attribuets, relationships: relationships)
      end
    end
  end
end
