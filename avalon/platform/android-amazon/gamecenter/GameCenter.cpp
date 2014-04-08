#include <avalon/GameCenter.h>

#include <string>

#include <jni.h>
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"

namespace avalon {

namespace helper {
namespace gamecenter {

/**
 * C++ -->> Java
 */

const char* const CLASS_NAME = "com/avalon/GameCenter";
    
static std::string& replaceAll(std::string& context, std::string const& from, std::string const& to)
{
    std::size_t lookHere = 0;
    std::size_t foundHere;
    while((foundHere = context.find(from, lookHere)) != std::string::npos)
    {
        context.replace(foundHere, from.size(), to);
        lookHere = foundHere + to.size();
    }
    return context;
}


void callStaticVoidMethod(const char* name)
{
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, CLASS_NAME, name, "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}

bool callStaticBoolMethod(const char* name)
{
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, CLASS_NAME, name, "()Z")) {
        bool result = (t.env->CallStaticBooleanMethod(t.classID, t.methodID) == JNI_TRUE);
        t.env->DeleteLocalRef(t.classID);
        return result;
    } else {
        return false;
    }
}

void callStaticVoidMethodWithString(const char* name, const char* idName)
{
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, CLASS_NAME, name, "(Ljava/lang/String;)V")) {
        jstring jIdName = t.env->NewStringUTF(idName);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, jIdName);
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(jIdName);
    }
}

void callStaticVoidMethodWithStringAndInt(const char* name, const char* idName, const int score)
{
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, CLASS_NAME, name, "(Ljava/lang/String;I)V")) {
        jstring jIdName = t.env->NewStringUTF(idName);
        t.env->CallStaticVoidMethod(t.classID, t.methodID, jIdName, (jint)score);
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(jIdName);
    }
}

} // namespace gamecenter
} // namespace helper

/**
 * Public API
 */

void GameCenter::login()
{
    helper::gamecenter::callStaticVoidMethod("login");
}

bool GameCenter::showAchievements()
{
    return helper::gamecenter::callStaticBoolMethod("showAchievements");
}

void GameCenter::postAchievement(const std::string &idName, int percentComplete, bool showBanner)
{
    std::string idNameStr(idName);
    replaceAll(idNameStr, ".", "_");
    helper::gamecenter::callStaticVoidMethodWithStringAndInt("postAchievement", idNameStr.c_str(), percentComplete);
}

void GameCenter::clearAllAchievements()
{
    helper::gamecenter::callStaticVoidMethod("clearAllAchievements");
}

bool GameCenter::showScores()
{
    return helper::gamecenter::callStaticBoolMethod("showScores");
}

void GameCenter::postScore(const std::string &idName, int score)
{
    std::string idNameStr(idName);
    replaceAll(idNameStr, ".", "_");
    helper::gamecenter::callStaticVoidMethodWithStringAndInt("postScore", idNameStr.c_str(), score);
}

void GameCenter::clearAllScores()
{
    helper::gamecenter::callStaticVoidMethod("clearAllScores");
}

} // namespace avalon
