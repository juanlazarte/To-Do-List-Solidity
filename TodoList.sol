// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract TodoList {
    address public owner;

    struct Task {
        uint id;
        string content;
        bool completed;
    }

    mapping(uint => Task) public tasks;
    uint public taskCount;

    event TaskCreated(uint id, string content, bool completed);
    event TaskCompleted(uint id, bool completed);
    event TaskDeleted(uint id);
    event TaskUpdate(uint id, string content);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can create task");
        _;
    }

    function createTask(string memory _content) public onlyOwner {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
        emit TaskCreated(taskCount, _content, false);
    }

    function completeTask(uint _taskId) public onlyOwner {
        require(_taskId > 0 && _taskId <= taskCount, "Invalid task Id");
        Task storage task = tasks[_taskId];
        task.completed = true;
        emit TaskCompleted(_taskId, true);
    }

    function deleteTask(uint _taskId) public onlyOwner {
        require(_taskId > 0 && _taskId <= taskCount, "Invalid task Id");
        delete tasks[_taskId];
        emit TaskDeleted(_taskId);
    }

    function updateTask(uint _taskId, string memory _newContent) public onlyOwner {
        require(_taskId > 0 && _taskId <= taskCount, "Invalid task Id");
        Task storage task = tasks[_taskId];
        task.content = _newContent;
        emit TaskUpdate(_taskId, _newContent);
    }

    function getTask(uint _taskId) public view returns(string memory, bool) {
        require(_taskId > 0 && _taskId <= taskCount, "Invalid task Id");
        Task storage task = tasks[_taskId];
        return (task.content, task.completed);
    }

    function getTaskCount() public view returns(uint) {
        return taskCount;
    }

    function isTaskCompleted(uint _taskId) public view returns(bool) {
        require(_taskId > 0 && _taskId <= taskCount, "Invalid task Id");
        Task storage task = tasks[_taskId];
        return task.completed;
    }
}