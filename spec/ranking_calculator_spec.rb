require 'ranking_calculator'

describe RankingCalculator do

  describe "read_input_file" do
    context "given a file name" do
      it "returns nil if file does not exist" do
        ranking = RankingCalculator::Ranking.new('fake-file.txt')
        data = ranking.read_input_file
        expect(data).to eql(nil)
      end
      it "returns data from an existing file" do
        ranking = RankingCalculator::Ranking.new('sample-input.txt')
        data = ranking.read_input_file
        expect(data).not_to be_empty
      end
    end
  end
  
  ranking = RankingCalculator::Ranking.new('sample-input.txt')
  data = ranking.read_input_file
  points_by_team = ranking.get_points_by_team(data)  
  describe "get_points_by_team" do
    context "given data from file" do
      it "returns points assigned to each team according to match results" do
        expect(points_by_team).not_to be_empty
        expect(points_by_team.is_a?(Hash)).to be true
        expect(points_by_team.length).to be 5
        expect(points_by_team.keys[0]).to eq("Lions")
        expect(points_by_team.values[0]).to be 5
        expect(points_by_team.keys[1]).to eq("Snakes")
        expect(points_by_team.values[1]).to be 1
        expect(points_by_team.keys[2]).to eq("Tarantulas")
        expect(points_by_team.values[2]).to be 6
        expect(points_by_team.keys[3]).to eq("FC Awesome")
        expect(points_by_team.values[3]).to be 1
        expect(points_by_team.keys[4]).to eq("Grouches")
        expect(points_by_team.values[4]).to be 0
      end
    end
  end
  
  sorted_teams_by_points = ranking.sort_teams_by_points(points_by_team)
  describe "sort_teams_by_points" do
    context "given a hash of points earned by teams" do
      it "returns sorted array according to points earned by teams" do
        expect(sorted_teams_by_points).not_to be_empty
        expect(sorted_teams_by_points.is_a?(Array)).to be true
        expect(sorted_teams_by_points.length).to be 5
        expect(sorted_teams_by_points[0][0]).to eq("Tarantulas")
        expect(sorted_teams_by_points[0][1]).to be 6
        expect(sorted_teams_by_points[1][0]).to eq("Lions")
        expect(sorted_teams_by_points[1][1]).to be 5
        expect(sorted_teams_by_points[2][0]).to eq("FC Awesome")
        expect(sorted_teams_by_points[2][1]).to be 1
        expect(sorted_teams_by_points[3][0]).to eq("Snakes")
        expect(sorted_teams_by_points[3][1]).to be 1
        expect(sorted_teams_by_points[4][0]).to eq("Grouches")
        expect(sorted_teams_by_points[4][1]).to be 0
      end
    end
  end
  
  output_data = ranking.set_team_place(sorted_teams_by_points)
  describe "set_team_place" do
    context "given an array of sorted teams by points" do
      it "returns sorted array with teams position in ranking table" do
        expect(output_data).not_to be_empty
        expect(output_data.is_a?(Array)).to be true
        expect(output_data.length).to be 5
        expect(output_data[0][0]).to eq("Tarantulas")
        expect(output_data[0][1]).to be 6
        expect(output_data[0][2]).to be 1
        expect(output_data[1][0]).to eq("Lions")
        expect(output_data[1][1]).to be 5
        expect(output_data[1][2]).to be 2
        expect(output_data[2][0]).to eq("FC Awesome")
        expect(output_data[2][1]).to be 1
        expect(output_data[2][2]).to be 3
        expect(output_data[3][0]).to eq("Snakes")
        expect(output_data[3][1]).to be 1
        expect(output_data[3][2]).to be 3
        expect(output_data[4][0]).to eq("Grouches")
        expect(output_data[4][1]).to be 0
        expect(output_data[4][2]).to be 5
      end
    end
  end
  
  ranking.write_output_file(output_data)
  describe "write_output_file" do
    context "given a sorted array with teams position" do
      it "returns a 'output.txt' file with the array data" do
        expect(File.exists? 'output.txt').to  be true
      end
    end
  end
  
end