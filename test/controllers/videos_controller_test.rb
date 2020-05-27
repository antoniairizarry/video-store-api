require "test_helper"

describe VideosController do
  VIDEO_FIELDS = ["id", "title", "release_date", "available_inventory"].sort
  it "must get index" do
    get videos_path
    
    must_respond_with :success
    expect(response.header['Content-Type']).must_include 'json'
  end
  
  it "will return all the proper fields for videos" do
    
    get videos_path
    #gets body of response as array or hash
    body = JSON.parse(response.body)
    
    expect(body).must_be_instance_of Array
    
    body.each do |video|
      expect(video).must_be_instance_of Hash
      expect(video.keys.sort).must_equal VIDEO_FIELDS
    end
  end
  
  it "returns an empty array if no videos exist" do
    Video.destroy_all
    
    get videos_path
    #gets body of response as array or hash
    body = JSON.parse(response.body)
    
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal 0
    
  end
  
  describe "show" do
    it "will return a hash with the proper fields for an existing video" do
      
      video = videos(:firstvideo)
      
      get video_path(video.id)
      
      body = JSON.parse(response.body)
      
      must_respond_with :success
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal VIDEO_FIELDS
    end
    
    it "will return a 404 request with json for a nonexistent video" do
      get video_path(-1)
      
      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['message']).must_equal 'Not found'
    end
  end

    describe "create" do

      it "can create a new video" do

        video_data = {
          video: {
            title: "Video",
            release_date: "11/11/1111",
            available_inventory: 13
          }
        }

        expect { post videos_path, params: video_data }.must_differ "Video.count", 1
        must_respond_with :created
      end
    end
  
end
