import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/AgentCtrl/cubit/agent_cubit.dart';
import '../Model/agent_model.dart';
// ============================================
// AGENT INPUT FIELD WIDGET WITH BLOC
// ============================================
class AgentInputField extends StatefulWidget {
  final Function(Agent)? onAgentSelected;
  final String? initialValue;
  final TextEditingController? controller;

  const AgentInputField({
    Key? key,
    this.onAgentSelected,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  _AgentInputFieldState createState() => _AgentInputFieldState();
}

class _AgentInputFieldState extends State<AgentInputField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  List<Agent> allAgents = [];
  List<Agent> filteredAgents = [];
  OverlayEntry? _overlayEntry;
  Agent? _lastValidSelection;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }

    // Load agents from API using Cubit
    context.read<AgentCubit>().GetAgent();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        Future.delayed(Duration(milliseconds: 200), () {
          _hideDropdown();
          _validateSelection();
        });
      }
    });
  }

  void _validateSelection() {
    final currentText = _controller.text.trim();

    if (currentText.isEmpty) return;

    final isValid = allAgents.any((agent) =>
    agent.agentName?.toLowerCase() == currentText.toLowerCase());

    if (!isValid) {
      // Revert to last valid selection
      _controller.text = _lastValidSelection?.agentName ?? '';
      if (mounted && currentText.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an agent from the list'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterAgents(String query) {
    if (query.isEmpty) {
      filteredAgents = allAgents.take(50).toList();
    } else {
      filteredAgents = allAgents.where((agent) {
        final name = agent.agentName?.toLowerCase() ?? '';
        final mobile = agent.mobile?.toLowerCase() ?? '';
        final shop = agent.shopName?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            mobile.contains(searchQuery) ||
            shop.contains(searchQuery);
      }).take(50).toList();
    }

    if (filteredAgents.isNotEmpty && _focusNode.hasFocus) {
      _showDropdown();
    } else {
      _hideDropdown();
    }

    if (mounted) setState(() {});
  }

  void _showDropdown() {
    _hideDropdown();

    if (filteredAgents.isEmpty && _controller.text.isEmpty) {
      filteredAgents = allAgents.take(50).toList();
    }

    if (filteredAgents.isEmpty || !mounted) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayEntry(builder: (_) => SizedBox.shrink());
    }

    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: filteredAgents.isEmpty
                ? Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No matching agents found',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: filteredAgents.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final agent = filteredAgents[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    agent.agentName ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: agent.shopName != null
                      ? Text(
                    agent.shopName!,
                    style: TextStyle(fontSize: 12),
                  )
                      : null,
                  trailing: agent.mobile != null
                      ? Text(
                    agent.mobile!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  )
                      : null,
                  onTap: () {
                    _controller.text = agent.agentName ?? '';
                    _lastValidSelection = agent;
                    widget.onAgentSelected?.call(agent);
                    _hideDropdown();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _clearText() {
    _controller.clear();
    _lastValidSelection = null;
    _filterAgents('');
    if (widget.onAgentSelected != null) {
      // Create empty agent to notify clearing
      widget.onAgentSelected?.call(Agent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgentCubit, AgentState>(
      listener: (context, state) {
        if (state is AgentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  context.read<AgentCubit>().GetAgent();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Update agent list when loaded
        if (state is AgentLoadedState) {
          allAgents = state.agentModel.agent ?? [];
          if (_controller.text.isEmpty) {
            filteredAgents = allAgents.take(50).toList();
          }
        }

        final isLoading = state is AgentLoadingState;
        final hasError = state is AgentErrorState;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(color: Colors.black),
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: "Select Agent Name",
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      fillColor: isLoading ? Colors.grey.shade200 : Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: 'font-bold',
                        fontSize: 11.sp,
                      ),
                      prefixIcon: isLoading
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : Icon(Icons.person),
                      suffixIcon: _controller.text.isNotEmpty && !isLoading
                          ? IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: _clearText,
                      )
                          : null,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterAgents,
                  ),
                ),
                if (hasError && !isLoading)
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.red),
                    onPressed: () {
                      context.read<AgentCubit>().GetAgent();
                    },
                    tooltip: 'Retry loading agents',
                  ),
              ],
            ),
            if (hasError && !isLoading)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'Failed to load agents',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        context.read<AgentCubit>().GetAgent();
                      },
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (state is AgentLoadedState && allAgents.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  '${allAgents.length} agents available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }
}