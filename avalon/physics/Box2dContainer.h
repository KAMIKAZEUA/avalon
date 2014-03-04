#ifndef AVALON_PHYSICS_BOX2DCONTAINER_H
#define AVALON_PHYSICS_BOX2DCONTAINER_H

#include "Box2D/Box2D.h"
#include "cocos2d.h"
#include <avalon/utils/utility.hpp>

class B2DebugDrawLayer;
namespace avalon { namespace physics { class CollisionManager; } }
namespace avalon { namespace physics { class Sprite; } }

namespace avalon {
namespace physics {

class Box2dContainer : public cocos2d::Node, public avalon::noncopyable
{
private:
    using NodeId = int*;
    using DeletePair = std::pair<b2Body*, cocos2d::Node*>;

    NodeId lastNodeId = nullptr;
    B2DebugDrawLayer* debugLayer = nullptr;
    std::shared_ptr<CollisionManager> collisionManager;
    std::unordered_map<NodeId, cocos2d::Node*> idToNode;
    std::unordered_map<cocos2d::Node*, NodeId> nodeToId;
    std::list<DeletePair> pendingDeletes;
    std::shared_ptr<b2World> world;

    NodeId generateId();
    void executePendingDeletes();

public:
    float32 timeStep = 1.0f / 60.0f;
    int32 velocityIterations = 8;
    int32 positionIterations = 3;
    float pixelsInMeter = 32; // FIXME: Read only
    b2FixtureDef defaultFixtureDef;

    CREATE_FUNC(Box2dContainer);
    bool init() override;

    void update(float delta) override;
    void enableDebugDraw(const bool enable);

    b2Vec2 convertToBox2d(const cocos2d::Point& pos);
    cocos2d::Point convertFromBox2d(const b2Vec2& pos);

    b2World& getWorld();
    CollisionManager& getCollisionManager();

    b2Body* createBody(const b2BodyDef& bodyDef);
    b2Body* createBody(const b2BodyDef& bodyDef, cocos2d::Node& node);

    void assignNode(b2Body& body, cocos2d::Node& node);
    void removeNode(cocos2d::Node& node);

    void destroyDelayed(b2Body& body);
    void destroyDelayed(b2Body& body, cocos2d::Node& node);
    void destroyDelayed(cocos2d::Node& node);

    template<typename T>
    T* getNode(const b2Fixture& fixture, const bool noException = false)
    {
        auto body = fixture.GetBody();
        if (!body) {
            if (noException) {
                return nullptr;
            } else {
                throw new std::invalid_argument("Fixture is not attached to a body yet");
            }
        }

        return getNode<T>(*body, noException);
    }

    template<typename T>
    T* getNode(const b2Body& body, const bool noException = false)
    {
        auto userDataPtr = body.GetUserData();
        if (!userDataPtr) {
            if (noException) {
                return nullptr;
            } else {
                throw new std::invalid_argument("b2Body does not contain any user data");
            }
        }

        auto nodeId = static_cast<NodeId>(userDataPtr);
        auto iter = idToNode.find(nodeId);
        if (iter == idToNode.end()) {
            if (noException) {
                return nullptr;
            } else {
                throw new std::out_of_range("Unable to find node");
            }
        }

        auto nodePtr = (*iter).second;
        auto resultPtr = dynamic_cast<T*>(nodePtr);
        if (!resultPtr) {
            if (noException) {
                return nullptr;
            } else {
                throw new std::out_of_range("Wrong node type");
            }
        }

        return resultPtr;
    }

    std::vector<b2Body*> getBodiesFromTouch(cocos2d::Touch& touch);

    template<typename T>
    std::vector<T*> getNodesFromTouch(cocos2d::Touch& touch)
    {
        std::vector<T*> result;

        for (auto& body : getBodiesFromTouch(touch)) {
            auto node = getNode<T>(*body, true);
            if (node) {
                result.push_back(node);
            }
        }

        return result;
    }
};

} // namespace physics
} // namespace avalon

#endif /* AVALON_PHYSICS_BOX2DCONTAINER_H */