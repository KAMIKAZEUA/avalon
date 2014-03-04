#include <avalon/ui/Alert.h>

#include <avalon/utils/assert.hpp>
#include "cocos2d.h"

namespace avalon {
namespace ui {

Alert::Alert()
{
}

Alert::Alert(Callback delegate)
: delegate(delegate)
{
}

void Alert::addButton(const unsigned int index, const std::string& label)
{
    buttons[index] = label;
}

void Alert::removeButton(const unsigned int index)
{
    buttons.erase(index);
}

std::string Alert::getButtonLabel(const unsigned int index) const
{
    return buttons.at(index);
}

void Alert::show()
{
    showAlert(title, message, buttons, delegate);
}

} // namespace ui
} // namespace avalon
