
from moviepy.editor import VideoFileClip, concatenate_videoclips, AudioFileClip
import sys, os
# /home/ubuntu/mk/AI_View
my_path = os.path.abspath(os.path.dirname(__file__))
def main(opt):
    """ return the url of concatenate video
    >>> main(opt={"output_dir":"my_video_scenes_tmp/","movie_shots":['my_video_scenes_tmp/test1.mp4', 'my_video_scenes_tmp/test2.mp4','my_video_scenes_tmp/test3.mp4','my_video_scenes_tmp/test4.mp4'],'user_id':'1'})
    'show_video_1.mp4' 
    """
    opt['output_dir'] = os.path.join(my_path, '../'+opt['output_dir'])
    for index, m in enumerate(opt['movie_shots']):
        opt['movie_shots'][index] = os.path.join(my_path, '../../'+m)
    clips = []
    for clip in opt['movie_shots']:
        clips.append(VideoFileClip(clip))
    # final_clip = concatenate_videoclips(clips)
    write_url = os.path.join(my_path, opt['output_dir']+"show_video_{}.mp4".format(opt['user_id']))    
    if 'audio' in opt.keys():
        a_path = os.path.join(my_path, '../../'+'my_video_scenes_tmp/music/'+opt['audio'])
        logo = os.path.join(my_path, '../../'+'my_video_scenes_tmp/'+opt['logo'])
        audio = AudioFileClip(a_path)
        final_clip = concatenate_videoclips(clips).set_audio(audio)
        final_clip = concatenate_videoclips([VideoFileClip(logo),final_clip])
        msg = final_clip.write_videofile(write_url)
    else:
        final_clip = concatenate_videoclips(clips)
        msg = final_clip.write_videofile(write_url)
    show_url = "show_video_{}.mp4".format(opt['user_id'])
    for clip in clips:
        clip.close()
    return show_url

if __name__ =='__main__':
    #opt={"output_dir":os.path.join(my_path, "../../my_videos_tmp/"),"movie_shots":[os.path.join(my_path, '../../my_videos_tmp/test1.mp4')],'user_id':'1'}
    #main(opt)
    import doctest
    doctest.testmod()


