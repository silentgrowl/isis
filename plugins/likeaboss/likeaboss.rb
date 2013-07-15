# Like a Boss

class LikeABoss < Isis::Plugin::Base
  def respond_to_msg?(msg, speaker)
    /like a (boss|baus|bau5)/i =~ msg
  end

  private

  def response_text
    "#{RESPONSES[rand(RESPONSES.size)]}"
  end

  RESPONSES = [
    'http://shirttrader.com/shirtimages/like-a-boss_3.jpg',
    'http://weknowmemes.com/wp-content/uploads/2011/09/like-a-boss-meme-cat.jpg',
    'http://weknowmemes.com/wp-content/uploads/2011/09/pissing-like-a-boss.jpg',
    'http://weknowmemes.com/wp-content/uploads/2011/09/like-a-boss-upskirt.jpg',
    'http://weknowmemes.com/wp-content/uploads/2011/09/like-a-boss-kid-getting-a-shot.jpg',
    'http://images.cheezburger.com/completestore/2011/2/20/a4ea536d-4b21-4517-b498-a3491437d224.jpg',
    'http://shirtoid.com/wp-content/uploads/2011/03/like-a-boss.jpg',
    'http://f.imagehost.org/0623/The-Lonely-Island-Like-A-Boss_000620_13-37-39_resize.jpg',
    'http://27.media.tumblr.com/tumblr_ldqvuzQWUp1qex40do1_500.gif',
    'http://www.thecollaredsheep.com/wp-content/uploads/2009/10/The-Lonely-Island-Like-a-Boss-300x177.jpg',
    'http://chzheroes.files.wordpress.com/2011/06/superheroes-batman-superman-like-a-boss.jpg',
    'http://www.stabilitees.com/store/image/cache/data/Designs/like-a-boss-t-shirt-500x500.jpg',
    'http://s3.amazonaws.com/kym-assets/photos/images/original/000/114/151/14185212UtNF3Va6.gif',
    'http://knotoryus.com/wp-content/uploads/2009/04/boss.png',
    'http://i1130.photobucket.com/albums/m532/Kaitlyn_Mathews/likeaboss.gif',
    'http://verydemotivational.files.wordpress.com/2011/11/demotivational-posters-like-a-boss3.jpg'
  ]
end
