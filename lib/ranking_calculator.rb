module RankingCalculator
  class Ranking
    
    #Initialize ranking object with a file name
    def initialize(file_name)
      @file_name = file_name
    end
    
    #Reads data from file sample-input.txt
    def read_input_file
      exist_file = File.exists? @file_name
      if exist_file
        file = File.open(@file_name, 'r')
        scores = []
        while line = file.gets do
          scores << line.strip
        end
        file.close
        scores        
      else
        puts 'Input file does not exists'
        nil
      end
    end
    
    #Gets points earned by each team according to match results
    def get_points_by_team(data)
      points_by_team = []
      data.each do |score|
        team_one = score.split(',')[0].gsub(score.split(',')[0].scan(/\d+/).first, '').strip
        team_two = score.split(',')[1].gsub(score.split(',')[1].scan(/\d+/).first, '').strip
        score_one = score.split(',')[0].scan(/\d+/).first.to_i
        score_two = score.split(',')[1].scan(/\d+/).first.to_i
        assing_points(points_by_team, score_one, score_two, team_one, team_two)
      end
      points_by_team.inject{|team, points| team.merge(points){|x, y, z| y + z}}
    end
    
    #Assign points, 3 for a won match, 1 for a tie match and 0 for a lost match
    def assing_points(points_by_team, score_one, score_two, team_one, team_two)
      if score_one > score_two
        points_by_team << {team_one => 3}
        points_by_team << {team_two => 0}
      elsif score_one < score_two
        points_by_team << {team_one => 0}
        points_by_team << {team_two => 3}
      else
        points_by_team << {team_one => 1}
        points_by_team << {team_two => 1}
      end
    end
    
    #Sorts teams according to points earned
    def sort_teams_by_points(data)
      data.sort_by {|key, value| value}.reverse
    end
    
    #Set teams position in ranking table according to points earned
    def set_team_place(data)
      place = 0
      data.each_with_index do |record, index|
        if record[1] < data[index - 1][1]
          place += 1 
          record.push(place)
        else
          (index == 0) ?  record.push(1) : record.push(place)
          place += 1 
        end
      end
      data
    end
    
    #write output file with the ranking table data
    def write_output_file(output_data)
      File.open('output.txt', 'w') { |file| 
        output_data.each do |data|
          points = (data[1] == 1) ?'pt' : 'pts'
          file.write("#{data[2]}. #{data[0]}, #{data[1]} #{points}\n")
        end
      }
    end
    
  end
end 