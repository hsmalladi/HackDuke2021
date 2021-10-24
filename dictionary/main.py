import requests
import json

def webscraper(request):
    request_json = request.get_json(silent=True)
    request_args = request.args
    key=''
    if request_json and 'word' in request_json:
        key = request_json['word']
    elif request_args and 'word' in request_args:
        key = request_args['word']
    else:
        key = 'simp'

    ret = getDefinition(key)
    ans = {}
    if ret is None:
        ans["word"] = ""
        ans["definition"] = ""
    else:
        ans["word"] = key
        ans["definition"] = ret
    return json.dumps(ans)


def getDefinition(word):
    try:
        word = word.replace(" ", "-")
        url = "https://www.dictionary.com/e/slang/WORD/"
        r = requests.get(url.replace("WORD", word))
        str = r.text
        distance = str.index("mean?");
        str = str[str.index("<p>", distance):str.index("</p>", distance)].replace("\n"," ");
        # print(str)
        str = str.replace("&#8220;", "\"");
        str = str.replace("&#8221;", "\"");
        str = str.replace("&#8217;", "\'");
        str = str.replace("&#8216;", "\'");
        ret = ""
        i = 0
        while (i < len(str)):
            if str[i] == "<":
                while str[i] != ">":
                    i+=1;
                i+=1
            if i >= len(str):
                break
            if str[i] == "<":
                i-=1
            ret += str[i]
            i+=1
        return ret.replace(">", "")
    except:
        return None
